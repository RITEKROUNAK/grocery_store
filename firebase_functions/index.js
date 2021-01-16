const functions = require('firebase-functions');
const admin = require('firebase-admin');
const config = require('./config');
const {
    UserBuilder
} = require('firebase-functions/lib/providers/auth');

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
const settings = {
    timestampInSnapshots: true
};
db.settings(settings);

const stripe = require('stripe')(config.stripe_config_test.SECRET_KEY);

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: req.body.amount,
            currency: req.body.currency,
            payment_method_types: ['card'],
        });

        return res.status(200).json({
            message: 'Success',
            data: paymentIntent
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});

exports.createPaymentMethod = functions.https.onRequest(async (req, res) => {
    try {
        const data = JSON.parse(req.body);

        const card = await stripe.paymentMethods.create({
            type: 'card',
            card: {
                number: data.number,
                exp_month: data.exp_month,
                exp_year: data.exp_year,
                cvc: data.cvc,
                name: data.name
            },
            billing_details: {
                address: {
                    city: data.billing_details.address.city,
                    // country: data.billing_details.address.country,
                    line1: data.billing_details.address.line1,
                    line2: data.billing_details.address.line2,
                    postal_code: data.billing_details.address.postal_code,
                    state: data.billing_details.address.state
                },
                email: data.billing_details.email,
                name: data.billing_details.name,
                phone: data.billing_details.phone
            }
        });
        // res.status(200).send(paymentIntent);
        return res.status(200).json({
            message: 'Success',
            data: card
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});

exports.confirmStripePayment = functions.https.onRequest(async (req, res) => {
    try {
        const confirmation = await stripe.paymentIntents.confirm(
            req.body.id, {
                payment_method: 'pm_card_visa'
            }
        );
        return res.status(200).json({
            message: 'Success',
            data: confirmation
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});

exports.createStripeRefund = functions.https.onRequest(async (req, res) => {
    try {
        const refund = await stripe.refunds.create({
            payment_intent: req.body.transactionId
        });

        // if (refund.status == 'failed' || refund.status == 'canceled') {
        //     return res.status(400).json({
        //         message: "Error",
        //         data: 'FAILED'
        //     })
        // }

        return res.status(200).json({
            message: 'Success',
            data: refund
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});

//notifications
exports.newOrderNotif = functions.firestore.document('Orders/{orderId}').onCreate(async (doc, context) => {

    const orderId = context.params.orderId;
    const orderStatus = doc.data().orderStatus;
    const uid = doc.data().custDetails.uid;

    var payload = null;

    payload = {
        notification: {
            title: 'Order #' + orderId,
            body: 'Your order was successfully placed',
            sound: 'default',
        },
        data: {
            type: 'orderStatus',
            orderId: orderId,
            orderStatus: orderStatus,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    return admin.firestore().collection('Users').doc(uid).get().then(async (queryResult) => {
        const tokenId = queryResult.data().tokenId;

        var uuid = createUUID();

        let notificationMap = {
            notificationBody: payload.notification['body'],
            notificationId: uuid,
            notificationTitle: payload.notification['title'],
            notificationType: 'ORDER_NOTIFICATION',
            orderId: orderId,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        await db.collection('UserNotifications').doc(uid).set({
            'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
            'unread': true,
        }, {
            merge: true
        });

        return admin
            .messaging()
            .sendToDevice(tokenId, payload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', tokenId);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });
    });
});

exports.notifyCustomer = functions.firestore.document('Orders/{orderId}').onUpdate(async (change, context) => {

    const orderId = context.params.orderId;
    const orderStatus = change.after.data().orderStatus;
    const uid = change.after.data().custDetails.uid;

    var payload = null;

    if (change.before.data().orderStatus === 'Processing' && change.after.data().orderStatus === 'Out for delivery') {
        // payload = {
        //     data: {
        //         orderId: orderId,
        //         orderStatus: orderStatus,
        //         title: 'Order #' + orderId,
        //         body: 'Your order is ' + orderStatus,
        //         notificationType: 'orderStatus'
        //     }
        // };
        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Your order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else if (
        (change.before.data().orderStatus === 'Out for delivery' || change.before.data().orderStatus === 'Processing') &&
        change.after.data().orderStatus === 'Delivered'
    ) {
        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Your order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else if (
        (change.before.data().orderStatus === 'Out for delivery' ||
            change.before.data().orderStatus === 'Processing' ||
            change.before.data().orderStatus === 'Delivered') &&
        change.after.data().orderStatus === 'Cancelled'
    ) {

        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Your order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else {
        return null;
    }

    return admin.firestore().collection('Users').doc(uid).get().then(async (queryResult) => {
        const tokenId = queryResult.data().tokenId;

        var uuid = createUUID();

        let notificationMap = {
            notificationBody: payload.notification['body'],
            notificationId: uuid,
            notificationTitle: payload.notification['title'],
            notificationType: 'ORDER_NOTIFICATION',
            orderId: orderId,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        await db.collection('UserNotifications').doc(uid).set({
            'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
            'unread': true,
        }, {
            merge: true
        });

        return admin
            .messaging()
            .sendToDevice(tokenId, payload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', tokenId);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });
    });
});

function createUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

exports.scheduledCheckTrending = functions.pubsub.schedule('every 24 hours')
    .onRun(async (context) => {
        console.log('Scheduled function that will run every 24 hrs');
        let data = [];
        let previousTrendingProdsIds = [];
        let newTrendingProdsIds = [];

        let productsColl = db.collection('Products');

        let products = await productsColl.orderBy('views', 'desc').get();

        console.log(products.docs);

        let i = 0;
        products.forEach(async (doc) => {
            if (doc.data().trending) {
                previousTrendingProdsIds.push(doc.data().id);
            }

            if (i < config.trending_prod_no) {
                newTrendingProdsIds.push(doc.data().id);
            }

            i++;
        });

        try {
            for (let index = 0; index < previousTrendingProdsIds.length; index++) {
                const id = previousTrendingProdsIds[index];

                await db.collection('Products').doc(id).update({
                    trending: false
                });

            }
        } catch (error) {
            console.log("Some error occurred.", error);
            return error;
        }

        //set new trending prods as true
        try {
            for (let index = 0; index < newTrendingProdsIds.length; index++) {
                const id = newTrendingProdsIds[index];

                await db.collection('Products').doc(id).update({
                    trending: true
                });

            }

        } catch (error) {
            console.log("Some error occurred.", error);
            return error;
        }

        //update analytics
        await db.collection('AdminInfo').doc('productAnalytics').update({
            trendingProducts: newTrendingProdsIds.length
        });

        console.log('Previous Trending Products :: ',
            previousTrendingProdsIds);
        console.log('New Trending Products :: ',
            newTrendingProdsIds);
        return true;

    });

//admin info 
exports.updateOrderAnalytics = functions.firestore.document('Orders/{orderId}').onUpdate(async (change, context) => {

    const orderBefore = change.before.data();
    const orderAfter = change.after.data();

    if (change.before.data().orderStatus === 'Processing' &&
        change.after.data().orderStatus === 'Processed' || change.after.data().orderStatus === 'Out for delivery'
    ) {
        //TODO: add to processed
        //TODO: remove from new

        try {
            snap = await db.collection('AdminInfo').doc('orderAnalytics').get();

            let newOrders = snap.data().newOrders;
            let newSales = snap.data().newSales;

            await db.collection('AdminInfo').doc('orderAnalytics').set({
                'processedOrders': admin.firestore.FieldValue.increment(1),
                'processedSales': admin.firestore.FieldValue.increment(parseFloat(change.after.data().charges.totalAmt)),
                'newOrders': newOrders - 1,
                'newSales': newSales - parseFloat(change.after.data().charges.totalAmt)
            }, {
                merge: true
            });
            return true;
        } catch (error) {
            console.log('Error sending message:', error);
            return error;
        }

    } else if (change.before.data().orderStatus === 'Processing' &&
        change.after.data().orderStatus === 'Cancelled') {

        //TODO: add to cancelled
        //TODO: remove from new

        snap = await db.collection('AdminInfo').doc('orderAnalytics').get();

        let newOrders = snap.data().newOrders;
        let newSales = snap.data().newSales;

        try {
            await db.collection('AdminInfo').doc('orderAnalytics').set({
                'cancelledOrders': admin.firestore.FieldValue.increment(1),
                'cancelledSales': admin.firestore.FieldValue.increment(parseFloat(change.after.data().charges.totalAmt)),
                'newOrders': newOrders - 1,
                'newSales': newSales - parseFloat(change.after.data().charges.totalAmt)
            }, {
                merge: true
            });
            return true;
        } catch (error) {
            console.log('Error sending message:', error);
            return error;
        }

    } else if ((change.before.data().orderStatus === 'Processed' || change.before.data().orderStatus === 'Out for delivery') &&
        change.after.data().orderStatus === 'Cancelled') {

        //TODO: add to cancelled
        //TODO: remove from processed

        snap = await db.collection('AdminInfo').doc('orderAnalytics').get();

        let processedOrders = snap.data().processedOrders;
        let processedSales = snap.data().processedSales;

        try {
            await db.collection('AdminInfo').doc('orderAnalytics').set({
                'cancelledOrders': admin.firestore.FieldValue.increment(1),
                'cancelledSales': admin.firestore.FieldValue.increment(parseFloat(change.after.data().charges.totalAmt)),
                'processedOrders': processedOrders - 1,
                'processedSales': processedSales - parseFloat(change.after.data().charges.totalAmt)
            }, {
                merge: true
            });
            return true;
        } catch (error) {
            console.log('Error sending message:', error);
            return error;
        }

    } else if (change.before.data().orderStatus === 'Out for delivery' &&
        change.after.data().orderStatus === 'Delivered'
    ) {
        //TODO: add to delivered
        //TODO: remove from processed

        try {
            snap = await db.collection('AdminInfo').doc('orderAnalytics').get();

            let processedOrders = snap.data().processedOrders;
            let processedSales = snap.data().processedSales;

            await db.collection('AdminInfo').doc('orderAnalytics').set({
                'deliveredOrders': admin.firestore.FieldValue.increment(1),
                'deliveredSales': admin.firestore.FieldValue.increment(parseFloat(change.after.data().charges.totalAmt)),
                'processedOrders': processedOrders - 1,
                'processedSales': processedSales - parseFloat(change.after.data().charges.totalAmt)
            }, {
                merge: true
            });
            return true;
        } catch (error) {
            console.log('Error sending message:', error);
            return error;
        }

    } else {
        return null;
    }
});

//inventory analytics

//TODO: send notification 

//   payload = {
//       notification: {
//           title: 'Order #' + orderId,
//           body: 'Your order is ' + orderStatus,
//           sound: 'default',
//       },
//       data: {
//           type: 'orderStatus',
//           orderId: orderId,
//           orderStatus: orderStatus,
//           click_action: 'FLUTTER_NOTIFICATION_CLICK',
//       }
//   };

//     return admin
//         .messaging()
//         .sendToDevice(tokenId, payload)
//         .then((response) => {
//             // Response is a message ID string.
//             console.log('TOKEN ID:: ', tokenId);
//             console.log('Successfully sent message:', response);
//             console.log(response.results[0].error);
//         })
//         .catch((error) => {
//             console.log('Error sending message:', error);
//         });
exports.updateLowInventoryAnalytics = functions.firestore.document('Products/{productId}').onUpdate(async (change, context) => {
    const inventoryBefore = change.before.data();
    const inventoryAfter = change.after.data();

    try {
        if ((inventoryAfter.quantity < inventoryBefore.quantity) && (inventoryAfter.quantity <= config.low_inventory_limit) && (inventoryBefore.quantity > config.low_inventory_limit)) {
            //TODO:  update analytics 
            await db.collection('AdminInfo').doc('inventoryAnalytics').set({
                'lowInventory': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if ((inventoryAfter.quantity > inventoryBefore.quantity) && (inventoryAfter.quantity > config.low_inventory_limit) && (inventoryBefore.quantity <= config.low_inventory_limit)) {
            snap = await db.collection('AdminInfo').doc('inventoryAnalytics').get();
            await db.collection('AdminInfo').doc('inventoryAnalytics').set({
                'lowInventory': snap.data().lowInventory - 1,
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateCreateCategoryAnalytics = functions.firestore.document('Categories/{categoryId}').onCreate(async (snap, context) => {
    try {
        await db.collection('AdminInfo').doc('inventoryAnalytics').set({
            'allCategories': admin.firestore.FieldValue.increment(1),
        }, {
            merge: true
        });
        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateDeleteCategoryAnalytics = functions.firestore.document('Categories/{categoryId}').onDelete(async (snap, context) => {
    try {
        snap = await db.collection('AdminInfo').doc('inventoryAnalytics').get();

        await db.collection('AdminInfo').doc('inventoryAnalytics').set({
            'allCategories': snap.data().allCategories - 1,
        }, {
            merge: true
        });
        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

//new message received
exports.updateMessageAnalytics = functions.firestore.document('Products/{productId}').onUpdate(async (change, context) => {
    const productBefore = change.before.data();
    const productAfter = change.after.data();

    let valsBefore = Object.values(productBefore.queAndAns);
    let valsAfter = Object.values(productAfter.queAndAns);

    console.log('VALS BEFORE');
    console.log(valsBefore.length);
    console.log('VALS AFTER');
    console.log(valsAfter.length);


    if (valsBefore.length < valsAfter.length) {
        await db.collection('AdminInfo').doc('messageAnalytics').set({
            'allMessages': admin.firestore.FieldValue.increment(1),
            'newMessages': admin.firestore.FieldValue.increment(1),
        }, {
            merge: true
        });
        return true;
    } else {
        return null;
    }
});

exports.updateAnsweredMessageAnalytics = functions.https.onRequest(async (req, res) => {
    try {
        snap = await db.collection('AdminInfo').doc('messageAnalytics').get();

        await db.collection('AdminInfo').doc('messageAnalytics').set({
            'newMessages': snap.data().newMessages - 1,
        }, {
            merge: true
        });
        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateCreateProductAnalytics = functions.firestore.document('Products/{productId}').onCreate(async (snap, context) => {
    try {
        if (snap.data().isListed && snap.data().featured) {
            await db.collection('AdminInfo').doc('productAnalytics').set({
                'allProducts': admin.firestore.FieldValue.increment(1),
                'activeProducts': admin.firestore.FieldValue.increment(1),
                'featuredProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        } else if (snap.data().isListed) {
            await db.collection('AdminInfo').doc('productAnalytics').set({
                'allProducts': admin.firestore.FieldValue.increment(1),
                'activeProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        } else if (snap.data().featured) {
            await db.collection('AdminInfo').doc('productAnalytics').set({
                'allProducts': admin.firestore.FieldValue.increment(1),
                'featuredProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        } else if (!snap.data().isListed) {
            await db.collection('AdminInfo').doc('productAnalytics').set({
                'allProducts': admin.firestore.FieldValue.increment(1),
                'inactiveProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        } else {
            return null;
        }

        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateActiveInactiveProductAnalytics = functions.firestore.document('Products/{productId}').onUpdate(async (change, context) => {
    const productBefore = change.before.data();
    const productAfter = change.after.data();

    try {
        if (productBefore.isListed === false && productAfter.isListed === true) {
            //product is listed

            snap = await db.collection('AdminInfo').doc('productAnalytics').get();

            await db.collection('AdminInfo').doc('productAnalytics').set({
                'inactiveProducts': snap.data().inactiveProducts - 1,
                'activeProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if (productBefore.isListed === true && productAfter.isListed === false) {
            //product is unlisted

            snap = await db.collection('AdminInfo').doc('productAnalytics').get();

            await db.collection('AdminInfo').doc('productAnalytics').set({
                'activeProducts': snap.data().activeProducts - 1,
                'inactiveProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});

// exports.updateTrendingProductAnalytics = functions.firestore.document('Products/{productId}').onUpdate(async (change, context) => {
//     const productBefore = change.before.data();
//     const productAfter = change.after.data();

//     try {
//         if (productBefore.trending === false && productAfter.trending === true) {
//             //product is trending

//             await db.collection('AdminInfo').doc('productAnalytics').set({
//                 'trendingProducts': admin.firestore.FieldValue.increment(1),
//             }, {
//                 merge: true
//             });
//             return true;
//         } else if (productBefore.trending === true && productAfter.trending === false) {
//             //product is not trending

//             snap = await db.collection('AdminInfo').doc('productAnalytics').get();

//             await db.collection('AdminInfo').doc('productAnalytics').set({
//                 'trendingProducts': snap.data().trendingProducts - 1,
//             }, {
//                 merge: true
//             });
//             return true;
//         } else {
//             return null;
//         }

//     } catch (error) {
//         console.log(error);
//         return null;
//     }
// });

exports.updateFeaturedProductAnalytics = functions.firestore.document('Products/{productId}').onUpdate(async (change, context) => {
    const productBefore = change.before.data();
    const productAfter = change.after.data();

    try {
        if (productBefore.featured === false && productAfter.featured === true) {
            //product is featured

            await db.collection('AdminInfo').doc('productAnalytics').set({
                'featuredProducts': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if (productBefore.featured === true && productAfter.featured === false) {
            //product is not featured

            snap = await db.collection('AdminInfo').doc('productAnalytics').get();

            await db.collection('AdminInfo').doc('productAnalytics').set({
                'featuredProducts': snap.data().featuredProducts - 1,
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateChangeCategory = functions.firestore.document('Categories/{categoryId}').onUpdate(async (change, context) => {
    const categoryBefore = change.before.data();
    const categoryAfter = change.after.data();

    try {
        if (categoryBefore.categoryName != categoryAfter.categoryName) {
            //name is changed
            let snapshots = await db.collection('Products').where('category', '==', categoryBefore.categoryName).get();

            for (let index = 0; index < snapshots.size; index++) {
                await db.collection('Products').doc(snapshots.docs[index].id).set({
                    'category': categoryAfter.categoryName,
                }, {
                    merge: true
                });

            }
            return true;
        } else if (categoryBefore.subCategories.length != categoryAfter.subCategories.length) {
            //subcategories changed
            // for (const subcategory in categoryBefore.subCategories) {

            // }

            //TODO: modify
            return null;

        } else {
            return null;
        }
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateAnsweredMessageAnalytics = functions.https.onRequest(async (req, res) => {
    try {
        snap = await db.collection('AdminInfo').doc('messageAnalytics').get();

        await db.collection('AdminInfo').doc('messageAnalytics').set({
            'newMessages': snap.data().newMessages - 1,
        }, {
            merge: true
        });
        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

//update user analytics
exports.updateCreateUserAnalytics = functions.firestore.document('Users/{userId}').onCreate(async (snap, context) => {
    try {
        await db.collection('AdminInfo').doc('userAnalytics').set({
            'allUsers': admin.firestore.FieldValue.increment(1),
            'activeUsers': admin.firestore.FieldValue.increment(1),
        }, {
            merge: true
        });

        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateBlockedUnblockedUserAnalytics = functions.firestore.document('Users/{userId}').onUpdate(async (change, context) => {
    const userBefore = change.before.data();
    const userAfter = change.after.data();

    try {
        if (userBefore.isBlocked === true && userAfter.isBlocked === false) {
            //user is unblocked

            snap = await db.collection('AdminInfo').doc('userAnalytics').get();

            await db.collection('AdminInfo').doc('userAnalytics').set({
                'blockedUsers': snap.data().blockedUsers - 1,
            }, {
                merge: true
            });
            return true;
        } else if (userBefore.isBlocked === false && userAfter.isBlocked === true) {
            //user is blocked

            await db.collection('AdminInfo').doc('userAnalytics').set({
                'blockedUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateActiveInactiveUserAnalytics = functions.firestore.document('Users/{userId}').onUpdate(async (change, context) => {
    const userBefore = change.before.data();
    const userAfter = change.after.data();

    try {
        if (userBefore.accountStatus === 'Active' && userAfter.accountStatus === 'Inactive') {
            //user is inactive

            snap = await db.collection('AdminInfo').doc('userAnalytics').get();

            await db.collection('AdminInfo').doc('userAnalytics').set({
                'activeUsers': snap.data().activeUsers - 1,
                'inactiveUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if (userBefore.accountStatus === 'Inactive' && userAfter.accountStatus === 'Active') {
            //user is active
            snap = await db.collection('AdminInfo').doc('userAnalytics').get();

            await db.collection('AdminInfo').doc('userAnalytics').set({
                'inactiveUsers': snap.data().inactiveUsers - 1,
                'activeUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});


//update delivery user analytics
exports.updateCreateDeliveryUserAnalytics = functions.firestore.document('DeliveryUsers/{userId}').onCreate(async (snap, context) => {
    try {
        var isActivated = snap.data().activated;

        if (isActivated) {
            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'allUsers': admin.firestore.FieldValue.increment(1),
                'inactiveUsers': admin.firestore.FieldValue.increment(1),
                'activatedUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        } else {
            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'allUsers': admin.firestore.FieldValue.increment(1),
                'inactiveUsers': admin.firestore.FieldValue.increment(1),
                'deactivatedUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
        }
        return true;
    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateDeactivatedDeliveryUserAnalytics = functions.firestore.document('DeliveryUsers/{userId}').onUpdate(async (change, context) => {
    const userBefore = change.before.data();
    const userAfter = change.after.data();

    try {
        if (userBefore.activated === true && userAfter.activated === false) {
            //user is deactivated

            snap = await db.collection('AdminInfo').doc('deliveryUserAnalytics').get();

            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'activatedUsers': snap.data().activatedUsers - 1,
                'deactivatedUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if (userBefore.activated === false && userAfter.activated === true) {
            //user is activated
            snap = await db.collection('AdminInfo').doc('deliveryUserAnalytics').get();

            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'deactivatedUsers': snap.data().deactivatedUsers - 1,
                'activatedUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});

exports.updateActiveInactiveDeliveryUserAnalytics = functions.firestore.document('DeliveryUsers/{userId}').onUpdate(async (change, context) => {
    const userBefore = change.before.data();
    const userAfter = change.after.data();

    try {
        if (userBefore.accountStatus === 'Active' && userAfter.accountStatus === 'Inactive') {
            //user is inactive

            snap = await db.collection('AdminInfo').doc('deliveryUserAnalytics').get();

            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'activeUsers': snap.data().activeUsers - 1,
                'inactiveUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else if (userBefore.accountStatus === 'Inactive' && userAfter.accountStatus === 'Active') {
            //user is active
            snap = await db.collection('AdminInfo').doc('deliveryUserAnalytics').get();

            await db.collection('AdminInfo').doc('deliveryUserAnalytics').set({
                'inactiveUsers': snap.data().inactiveUsers - 1,
                'activeUsers': admin.firestore.FieldValue.increment(1),
            }, {
                merge: true
            });
            return true;
        } else {
            return null;
        }

    } catch (error) {
        console.log(error);
        return null;
    }
});


//admin notifications


//notifications
exports.sellerNewOrderNotif = functions.firestore.document('Orders/{orderId}').onCreate(async (doc, context) => {

    const orderId = context.params.orderId;
    const orderStatus = doc.data().orderStatus;
    const custUid = doc.data().custDetails.uid;
    var uuid = createUUID();

    var adminPayload = null;

    adminPayload = {
        notification: {
            title: 'Order #' + orderId,
            body: 'You received a new order',
            sound: 'default',
        },
        data: {
            type: 'orderStatus',
            orderId: orderId,
            orderStatus: orderStatus,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    var tokens = [];
    var uids = [];

    //get all admin tokens
    return admin.firestore().collection('Admins').get().then(async (queryResult) => {
        snapshots = queryResult;

        queryResult.forEach(element => {
            var tempToken = element.data().tokenId;

            if (tempToken.length > 0) {
                tokens.push(tempToken);
                uids.push(element.data().uid);
            }
        });

        let notificationMap = {
            notificationBody: adminPayload.notification['body'],
            notificationId: uuid,
            notificationTitle: adminPayload.notification['title'],
            notificationType: 'ORDER_NOTIFICATION',
            orderId: orderId,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        //update all admins

        for (let index = 0; index < tokens.length; index++) {
            const token = tokens[index];
            const uid = uids[index];

            await db.collection('AdminNotifications').doc(uid).set({
                'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
                'unread': true,
            }, {
                merge: true
            });

        }

        return admin
            .messaging()
            .sendToDevice(tokens, adminPayload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', tokens);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });


    });
});


exports.sellerOrderUpdateNotif = functions.firestore.document('Orders/{orderId}').onUpdate(async (change, context) => {

    const orderId = context.params.orderId;
    const orderStatus = change.after.data().orderStatus;
    const uid = change.after.data().custDetails.uid;
    var uuid = createUUID();

    var payload = null;

    if (change.before.data().orderStatus === 'Processing' && change.after.data().orderStatus === 'Out for delivery') {

        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else if (
        (change.before.data().orderStatus === 'Out for delivery' || change.before.data().orderStatus === 'Processing') &&
        change.after.data().orderStatus === 'Delivered'
    ) {
        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else if (
        (change.before.data().orderStatus === 'Out for delivery' ||
            change.before.data().orderStatus === 'Processing' ||
            change.before.data().orderStatus === 'Delivered') &&
        change.after.data().orderStatus === 'Cancelled'
    ) {
        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'Order is ' + orderStatus,
                sound: 'default',
            },
            data: {
                type: 'orderStatus',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else {
        return null;
    }

    var tokens = [];
    var uids = [];

    //get all admin tokens
    return admin.firestore().collection('Admins').get().then(async (queryResult) => {

        queryResult.forEach(element => {
            var tempToken = element.data().tokenId;

            tokens.push(tempToken);
            uids.push(element.data().uid);
        });

        let notificationMap = {
            notificationBody: payload.notification['body'],
            notificationId: uuid,
            notificationTitle: payload.notification['title'],
            notificationType: 'ORDER_NOTIFICATION',
            orderId: orderId,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        // let notificationMap = {
        //     notificationBody: adminPayload.notification['body'],
        //     notificationId: uuid,
        //     notificationTitle: adminPayload.notification['title'],
        //     notificationType: 'ORDER_NOTIFICATION',
        //     orderId: orderId,
        //     timestamp: admin.firestore.Timestamp.fromDate(new Date())
        // };

        //update all admins
        for (let index = 0; index < tokens.length; index++) {
            const token = tokens[index];
            const uid = uids[index];

            await db.collection('AdminNotifications').doc(uid).set({
                'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
                'unread': true,
            }, {
                merge: true
            });
        }

        return admin
            .messaging()
            .sendToDevice(tokens, payload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', tokens);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });


    });
});


exports.userReportNotif = functions.firestore.document('UserReports/{reportId}').onCreate(async (snap, context) => {

    const reportId = context.params.reportId;
    const report = snap.data().reportDescription;
    const productId = snap.data().productId;
    const userId = snap.data().uid;
    const userName = snap.data().userName;

    var uuid = createUUID();

    var payload = null;

    payload = {
        notification: {
            title: 'User report',
            body: `Product #${productId} was reported: "${report}"`,
            sound: 'default',
        },
        data: {
            type: 'userReport',
            productId: productId,
            reportDesc: report,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    var tokens = [];
    var uids = [];

    //get all admin tokens
    return admin.firestore().collection('Admins').get().then(async (queryResult) => {

        queryResult.forEach(element => {
            var tempToken = element.data().tokenId;

            tokens.push(tempToken);
            uids.push(element.data().uid);
        });

        let notificationMap = {
            notificationBody: payload.notification['body'],
            notificationId: uuid,
            notificationTitle: payload.notification['title'],
            notificationType: 'USER_REPORT_NOTIFICATION',
            productId: productId,
            uid: userId,
            report: report,
            userName: userName,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        //update all admins
        for (let index = 0; index < tokens.length; index++) {
            const token = tokens[index];
            const uid = uids[index];

            await db.collection('AdminNotifications').doc(uid).set({
                'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
                'unread': true,
            }, {
                merge: true
            });
        }

        return admin
            .messaging()
            .sendToDevice(tokens, payload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', tokens);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });


    });
});

exports.delveryUserOrderAssignedNotif = functions.firestore.document('Orders/{orderId}').onUpdate(async (change, context) => {

    const orderId = context.params.orderId;
    const orderStatus = change.after.data().orderStatus;
    const uid = change.after.data().deliveryDetails.uid;
    var uuid = createUUID();

    var payload = null;

    if (change.before.data().orderStatus === 'Processing' || change.before.data().orderStatus === 'Processed' &&
        change.after.data().orderStatus === 'Out for delivery') {

        payload = {
            notification: {
                title: 'Order #' + orderId,
                body: 'New assignment received',
                sound: 'default',
            },
            data: {
                type: 'orderAssigned',
                orderId: orderId,
                orderStatus: orderStatus,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
    } else {
        return null;
    }

    //get token
    return admin.firestore().collection('DeliveryUsers').doc(uid).get().then(async (queryResult) => {

        let notificationMap = {
            notificationBody: payload.notification['body'],
            notificationId: uuid,
            notificationTitle: payload.notification['title'],
            notificationType: 'ORDER_ASSIGNED_NOTIFICATION',
            orderId: orderId,
            timestamp: admin.firestore.Timestamp.fromDate(new Date())
        };

        await db.collection('DeliveryUserNotifications').doc(uid).set({
            'notifications': admin.firestore.FieldValue.arrayUnion(notificationMap),
            'unread': true,
        }, {
            merge: true
        });

        return admin
            .messaging()
            .sendToDevice(queryResult.data().tokenId, payload)
            .then((response) => {
                // Response is a message ID string.
                console.log('TOKEN ID:: ', queryResult.data().tokenId);
                console.log('Successfully sent message:', response);
                console.log(response.results[0].error);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });


    });
});


exports.createRazorpayOrderId = functions.https.onRequest(async (req, res) => {
    try {
        var amount = req.body.amount;

        var request = require('request-promise');
        
        var options = {
        'method': 'POST',
        'url': 'https://api.razorpay.com/v1/orders',
        'headers': {
            'Content-Type': 'application/json',
            'Authorization': `${config.razorpay_auth_token}` //TODO: CHANGE THIS TO YOUR AUTHORIZATION TOKEN 
        },
        body: JSON.stringify({
            "amount": amount,
            "currency": config.currency,
        })};

        var resp = await request(options)

        return res.status(200).json({
            message: 'Success',
            data: JSON.parse(resp)
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});

exports.initiateRefundForRazorpay = functions.https.onRequest(async (req, res) => {
    try {
        var paymentId = req.body.paymentId;

        var request = require('request-promise');
        
        var options = {
        'method': 'POST',
        'url': `https://api.razorpay.com/v1/payments/${paymentId}/refund`,
        'headers': {
            'Content-Type': 'application/json',
            'Authorization': `${config.razorpay_auth_token}` //TODO: CHANGE THIS TO YOUR AUTHORIZATION TOKEN 
        }};

        var resp = await request(options)

        return res.status(200).json({
            message: 'Success',
            data: JSON.parse(resp)
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});


exports.createAdminAccount = functions.https.onRequest(async (req, res) => {
    try {
        var email = req.body.email;
        var mobileNo = req.body.mobileNo;
        var url = req.body.url;
        var name = req.body.name;
        var password = req.body.password;

     var user = await admin.auth().createUser({
            email: `${email}`,
            password: 'secretPassword',
        });
         
        await db.collection('Admins').doc(user.uid).set({
            'uid': `${user.uid}`,
            'mobileNo': mobileNo,
            'email':email,
            'activated': true,
            'accountStatus': 'Active',         
            'name': name,
            'profileImageUrl': url,
            'primaryAdmin': false,
            'tokenId': '',
            'password': password,
            'timestamp': admin.firestore.Timestamp.fromDate(new Date()),
        }); 


        return res.status(200).json({
            message: 'Success',
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            message: "Error",
            data: error
        })
    }
});